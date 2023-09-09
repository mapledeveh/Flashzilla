# Flashzilla

## Challenge

1. When adding a card, the textfields keep their current text – fix that so that the textfields clear themselves after a card is added.
    - assigning an empty string to *answer* and *prompt* at the end of the *saveCard()* function seems to be the easiest way to fix this.

2. If you drag a card to the right but not far enough to remove it, then release, you see it turn red as it slides back to the center. Why does this happen and how can you fix it?
    - changing the condition from > to >= seems to have fixed the bug
    > offset.width >= 0 ? .green : .red

3. For a harder challenge: when the users gets an answer wrong, add that card goes back into the array so the user can try it again. Doing this successfully means rethinking the **ForEach** loop, because relying on simple integers isn’t enough – your cards need to be uniquely identifiable.
    - adding a boolean argument to the *removal* closure seems easiest. Creating a new card that has the same prompt and answer, adding it to the beginning of the array (or rather the end of the stack) before deleting the card is much simpler

Still thirsty for more? Try upgrading our loading and saving code in two ways:

1. Make it use documents JSON rather than **UserDefaults** – this is generally a good idea, so you should get practice with this.
2. Try to find a way to centralize the loading and saving code for the cards. You might need to experiment a little to find something you like!