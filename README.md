# Wake Me Up
An iOS alarm, built with swift, that relies on the user's friends to ensure they are awake.

The Twilio API is used to send text messages to a user's friend if the oversleep, and Heroku is used
to host the servers which manage the sending of messages. Twilio credentials are stored in
the server to prevent users from unpacking the app and stealing the account details.
