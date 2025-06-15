# VSCode overlay with custom CSS/JS injection support
{ prev }:

let
  # Platform-specific app structure paths
  vscodeAppPath =
    if prev.stdenv.isDarwin
    then "Applications/Visual Studio Code.app/Contents/Resources/app/out"
    else "resources/app/out";

  # External files configuration
  externalDir = ../dotfiles/vscode/external;
  externalFiles = builtins.attrNames (builtins.readDir externalDir);

  # Generate HTML injection tags for external files
  mkInjectionTag = file:
    if prev.lib.hasSuffix ".css" file then
      "<link rel=\"stylesheet\" href=\"./customize/${file}\">"
    else if prev.lib.hasSuffix ".js" file then
      "<script src=\"./customize/${file}\"></script>"
    else "";

  injectionHtml = builtins.concatStringsSep "\n"
    (builtins.map mkInjectionTag externalFiles);
in

prev.pkgs.vscode-unstable.vscode.overrideAttrs (old: {
  postInstall = old.postInstall or "" + ''
    cd $out
    
    # Setup directories
    mkdir -p customize
    mkdir -p "$out/${vscodeAppPath}/vs/code/electron-sandbox/workbench/customize/"
    
    # Copy external CSS/JS files to VSCode workbench directory  
    ${builtins.concatStringsSep "\n" (
      builtins.map (file: 
        "cp \"${externalDir}/${file}\" \"$out/${vscodeAppPath}/vs/code/electron-sandbox/workbench/customize/\""
      ) externalFiles
    )}

    # Create TypeScript injection script
    cat > $out/customize/inject.ts << 'EOF'
    import * as path from 'path';
    import * as fs from 'fs';

    /**
     * Locate VSCode workbench HTML file across different versions
     */
    function findWorkbenchHtml(installationPath: string): string | null {
      console.log('Installation path:', installationPath);
      const base = path.join(installationPath, 'vs', 'code', 'electron-sandbox', 'workbench');
      
      const candidates = [
        'workbench.html',
        'workbench-customize.html', 
        'workbench.esm.html'
      ];
      
      for (const candidate of candidates) {
        const htmlFile = path.join(base, candidate);
        if (fs.existsSync(htmlFile)) {
          console.log('Found workbench HTML at:', htmlFile);
          return htmlFile;
        }
      }
      
      console.error('Unable to locate VS Code workbench HTML file');
      return null;
    }

    /**
     * Apply title bar style patches to main.js
     */
    function patchMainJS(installationPath: string): void {
      const mainJSPath = path.join(installationPath, 'main.js');
      if (fs.existsSync(mainJSPath)) {
        const mainJSContent = fs.readFileSync(mainJSPath, 'utf8');
        const modifiedMainJS = mainJSContent.replaceAll(
          'experimentalDarkMode:!0', 
          'experimentalDarkMode:!0, "frame":false, "titleBarStyle":"hiddenInset"'
        );
        fs.writeFileSync(mainJSPath, modifiedMainJS);
        console.log('Applied title bar style patch');
      }
    }

    /**
     * Main injection function - injects external CSS/JS and applies patches
     */
    export function inject(): void {
      const installationPath = '${vscodeAppPath}';
      const htmlFile = findWorkbenchHtml(installationPath);
      
      if (!htmlFile) {
        throw new Error('Failed to find workbench HTML file for injection');
      }
      
      console.log('Injection target:', htmlFile);
      const injectionHtml = '${injectionHtml}';
      
      // Inject external CSS/JS files
      if (injectionHtml) {
        const htmlContent = fs.readFileSync(htmlFile, 'utf8');
        
        if (!htmlContent.includes('<!-- Injected by customize')) {
          const modifiedHtml = htmlContent.replace('</head>', 
            injectionHtml + '\n<!-- Injected by customize -->\n</head>');
          fs.writeFileSync(htmlFile, modifiedHtml);
          console.log('Successfully injected external files into workbench HTML');
        } else {
          console.log('External files already injected, skipping');
        }
      }

      // Apply additional patches
      patchMainJS(installationPath);
    }
    EOF

    # Create and execute runner script
    echo "import { inject } from '$out/customize/inject.ts'; inject();" > $out/customize/run-inject.ts
    bun $out/customize/run-inject.ts
  '';

  buildInputs = old.buildInputs ++ [
    prev.pkgs.bun
  ];
})
