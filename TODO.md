# General Admission Shows
- [ ] Auto-adjust reservable ticket quantity based on available seats for section
- [ ] Add GA tickets to order form
- [ ] Add GA tickets to order total calculation

# Shows Index
- [ ] Finish
- [ ] Cache each show partial

# Shows#show
- [ ] Add general information
- [ ] Add upsales
- [ ] Add upsales to shopping cart
- [ ] Add upsales to order form
- [ ] Add customer questions to order form

# Seating Charts
- [ ] Convert slide over component to use el-transition

## Sections
- [ ] Autofocus section when a new section is rendered

# Users
- [ ] Add password requirements
- [ ] Add sign out button and system test for signing out
- [ ] Don't let logged in users go to login page
- [ ] Add profile editing
- [ ] Add stay logged in cookie
- [ ] Password reset

# Checkout
- [ ] Test invalid credit card info
- [ ] Copy credit card SVGs from stripe payment element to use in application

# Guest Conversion
- [ ] Send "welcome, set your password" email

# Shopping Cart
- [ ] Clicking on a show link in the shopping cart doesn't work
- [ ] See if there's a way to use peer-empty to display a "nothing in your cart" message

# Merch
- [ ] Add ordering of merch

# Bugs
- [ ] Adding "required" field to errored fields makes the fields look weird when they have the "$" and "USD" stuff in them. (see new show form, submit a section with no pricing)
- [ ] Update merch, add category but don't fill anything in then save. Should pass validation but doesn't
- [ ] You can uncheck the "All" chip
- [ ] Order form not validating address properly
- [ ] Add a bunch of merch to the shopping cart from the merch index, then open the shopping cart. The z-index is messed up or something
- [ ] Deleting an existing seat on an existing seating chart does nothing
- [ ] Ticket types form - convenience fee error messages are not styled properly
- [ ] Removing a section on the seating chart form closes the slideout
- [ ] Rapidly clicking the trash can on the shopping cart dropdown will eventually result in a 404 which replaces the shopping cart with "No content"
- [ ] Filtering merch by category doesn't seem to be working right?

- Outstanding merch orders screen
- Shipped button on Merch
