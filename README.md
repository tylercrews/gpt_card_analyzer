# gpt_card_analyzer

TO DO:
✅ rotate your public api keys in firebase_options, and save them to github as secrets next time for security's sake. Figure out if they can be environment variables that can be gitignored here so you can still save them online without exposing them

phase 1. Barebones necessities - making queries and writing to the google sheet, 
✅ get program set up to make a query to either (one of) chatgpt or gemini
✅ get program to set up to make a query via firebase_vertexai instead of the regular api (allows security, no storing key in app)
- -  'FirebaseVertexAI' is deprecated and shouldn't be used. `FirebaseVertexAI` library and `firebase_vertexai` package have been renamed and replaced by the new Firebase AI SDK: `FirebaseAI` in `firebase_ai` package. See details in the [migration guide](https://firebase.google.com/docs/vertex-ai/migrate-to-latest-sdk).

* get program set up to use an image as input for the llm query
* get app set up to allow user to take pic or upload pic to app (to use for query)

* the google sheets looks like we're gonna need to split this into frontend and backend:
* * the google sheets editor should be a standalone python function running on firebase cloud functions.
* * integration with firebase authentication will allow users to set up an account.
* * once the user has an account, there should be a workflow to register a sheet (can do one sheet per card type eventually)
* * - the user is instructed how to set up permissions on the sheet by inviting the app's Service Account email to be an editor of the sheet.
* * - the user presses a button to indicate that they have registered the email as an editor, and the backend does a test edit to make sure that it can successfully edit the sheet. This either produces a success screen on the app, or tells them to retry setup.
* * a simple firestore registry of {user: {card_type: sheet_name, card_type_2: sheet2_name}} will allow the backend to make the edit to the correct sheet. Only successfully registered sheets will be in their keystore.
* * - need to make some kind of process for occasionally testing that the registered sheet still works so that you don't encounter errors during live queries.
* * - there needs to be some kind of error handling to fix the sheet registration during a live query when a write fails.
* get program set up to write to a google sheets document
* * get program set up to write to a second tab in a sheet
* get program set up to allow program permission to access google sheet


phase 2. UI beautification
* refine query to get more specific output and clarify the workflow
* draw out the popup for "is this your card?" - include menu to click on the specifics about the card (graded, sport, etc) and either proceed or try again to identify the card
* need to have a way to display how many tokens are paid for on the account, and how many are being used per upload

* figure out how to hide public api key? Is it possible?
* * firebase cloud functions secrets?
* multi-model referencing
* set up queries to the other llm
* * can either choose one, the other, or both, and get charged accordingly with no additional markup
* set up queries for other card games - magic, yugioh, etc
* * all in one spreadsheet? Should probably be able to swap sheets, or have multiple plugged in


phase 3. payments
* set up app for payments
* * in app purchases for tokens count as digital purchases - required to be handled by the respective app stores (play and app stores) and incur a 15%-30% charge for amount paid.
* * need to implement RevenueCat to handle this
* * for every $10 spent, $3 will go to the app store, so make sure that is clearly shown and the user is given the correct amount of tokens. Should provide a little receipt
* * every purchase should also provide an estimate for about how many cards you'll be able to look up
* calculations for how many tokens user is using, updating the firestore with the new total after every query