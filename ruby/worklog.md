25/11/17
## Preamble
- Thought it might be a good idea to write something about refactoring
- Was looking for a refactoring game
- Happened on this which I have seen Sandi Metz run through what feels like a long time ago
- Going to try my hand at it and document my progress

## Thoughts
- Cover features in tests
- Found a bug in max quality for regular items

## Refactoring strategies
- Things are going to get worse before they get better
- simplify the code so what is actually important can show

26/11/17
## Thoughts
- Switches are based on the item name seems like a class is needed here
- Created a class called Artifact that has programmable interfaces for updating item quality,
    clamping max and min qualities and updating sell in
- This has removed the interleaving of conditions entirely and the interface is simplified the only method that needs to be called in `apply_item_rules`
- On completion I think if originally the duplication of code was left in this would have led to easier abstraction versus the initial attempt at reuse
eg. Backstage pass logic was nested deep within just to reuse incrementing the item.quality by 1, the current solution I have arrived is basically a fancy switch
with all reuse removed. Reinforces to me, bad abstractions are worse than duplication.

