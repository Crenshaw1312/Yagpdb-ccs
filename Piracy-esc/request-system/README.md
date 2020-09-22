# Request system
I made this because I got very tired of having to go to 1337x.to or The Pirate Bay to get a link and possibly risk my digital saftey.
So I figured I'll make a request system that's easy to use, clean, promotes sever booting, and boosts sever community.

> __ALL OF THESE COMMANDS MUST BE USED TOGETHER__

## System Overview
__1.__ Asumming you're using the regex provided (^-req(uest)?) the user will start by doing their request `-request <Item name>`

__2.__ This will send a embed/message to the specified channel so the requests won't get buried in conversation, like a suggestion

__3.__ Once an "Uploader" decides to upload, or has uploaded, the requested item, they can react with the blue circle emoji. By doing
this the Uploader will have triggered the bot to __a.__ Notify the user thier request have been done __b.__ Give the Uploader rep __c.__ 
Delete the request/message from the request channel.

__4.__ Optionally, you can have the Uploaders shown for who has the most uploads/rep, the topuploaders file is an exception to the 
"All of these commands must be used together" rule.

### Searching
This commands comes with search query links to a couple of sites, you can toggle which ones you want shown/used in the request.go file. You can also just have no fields at all. If  you want another site added you can [join my discord server](https://discord.gg/2CGN4A9).
 
### Booster Rep

   **-** If the person who requsted the item is a server booster, then their request will be modified so it gives whomever Uploads said item 2 rep.

   **-** If the Uploader is a server booster then on all of their uploads it will be 2 rep. This means a Uploader can get 3 
rep if they themselves is a server booster and the the person who requested the item is also a sever booster.

### The Other Reactions
There is also three other reactions besides blue_circle.

__Blue_Circle__ The item has been uploaded/will be uploaded

__Red_Circle__ This allows the Uploader or the Requester to delete their request.

__Yellow_Circle__ This is if you already have the item requested.

__Purple_Circle__ If there is not enough information provided.
