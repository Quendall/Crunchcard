from server.card_api import *

cc = client_connector()

cards = cc.get_cards()
# print([dict(question=q, answer=a) for (q, a) in cards])
print(cards)
