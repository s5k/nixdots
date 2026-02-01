Based on our previous analysis, now generate the complete Magento 2 implementation.

**Follow Magento 2 Best Practices:**

1. **LAYOUT XML:**

   - Use proper XML schema declarations
   - Follow Magento's naming conventions for blocks/containers
   - Use `after/before` attributes for positioning when possible
   - Add custom CSS classes via `css_class` argument for blocks or `htmlClass` attribute for containers
   - Never remove core blocks without explicit permission

2. **TEMPLATES (.phtml):**

   - Preserve all PHP logic, translations, and form keys
   - Use `$block->escapeHtml()` for all output
   - Maintain existing data-mage-init and KO bindings
   - Keep original template structure where possible
   - Add Tailwind classes alongside existing Magento classes
   - Extend existing templates instead of replacing them when feasible

3. **CSS/LESS:**

   - Convert Tailwind utilities to Magento's REM-based system (14px = 1.4rem)
   - Use Magento's UI library variables (`@color-`, `@indent__`, `@font-`)
   - Nest selectors within custom class names to avoid conflicts
   - Add responsive mixins (`.media-width()`)
   - Create new LESS files in theme's `web/css/source/` directory

4. **JAVASCRIPT/KO:**

   - Extend existing components, don't replace them
   - Preserve existing `data-bind` attributes
   - Add custom classes via KO observables when needed
   - Follow AMD module patterns

5. **HTML Knockout Templating:**
   - Maintain existing `data-bind` attributes
   - Use Magento's UI components properly

**Output format:**
For each file to create/modify:

1. File path
2. Change type (create new / override existing)
3. Complete file content
4. Explanation of key decisions

Include any required Magento CLI commands for deployment.
