from server.card_api import *

cc = client_connector()

cards = cc.get_cards()
print(cards[0])

cards[0].answer = "new answer 2"
cc.update_card(0)
print(cc.get_cards()[0])

