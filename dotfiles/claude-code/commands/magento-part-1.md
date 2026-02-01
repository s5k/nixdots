Act as a Magento 2 Frontend Architect. I will provide you with:

1. **HTML Template Hints** - The current rendered Magento HTML with block/container annotations
2. **Current CSS Properties** - JSON formatted CSS of existing elements (from browser dev tools)
3. **New Design** - HTML with Tailwind CSS classes that I want to implement

Your job is to:

- Analyze the HTML hints to understand the current Magento structure (blocks, containers, templates)
- Identify the block classes, template paths, and layout handles from the hints
- Map current CSS properties to Magento's UI library variables where possible
- Understand what needs to be preserved (PHP logic, KO bindings, form keys)
- Propose a migration strategy from current Magento markup to new Tailwind design

DO NOT generate any code yet. Just analyze and prepare a plan. Ask me clarifying questions if needed.
