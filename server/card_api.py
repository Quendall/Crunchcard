from uuid import UUID

from cassandra.cluster import (
    Cluster,
    ExecutionProfile,
    EXEC_PROFILE_DEFAULT,
    Session,
    ResultSet,
)
from cassandra.policies import DCAwareRoundRobinPolicy, TokenAwarePolicy
from cassandra.auth import PlainTextAuthProvider
from dataclasses import dataclass


@dataclass
class User:
    id: UUID
    name: str
    email: str
    role_id: int


@dataclass
class Participant:
    user_id: UUID
    name: str
    email: str
    role_id: int


@dataclass
class CardSet:
    set_id: UUID
    title: str
    desciption: str
    folder: str
    permissions: {int, Participant}


@dataclass
class Card:
    card_id: UUID
    set_id: UUID
    is_deleted: bool
    question: str
    answer: str
    updated_at: str
    created_at: str


@dataclass
class Folder:
    pass


class client_connector:
    def __init__(self) -> None:
        self.cluster = self.getCluster()
        self.session: Session = self.cluster.connect(
            "card"
        )  # connect to 'card' keyspace

        # TODO: remove hardcoding
        self.cardset = "Rust string types"
        self.user = User(
            "801f5725-95a8-4e00-adda-526beefe40e6",
            "Kendall Clement",
            "kendall.clement@gmail.com",
            1,
        )
        self.set_id = UUID("f31d55d4-5365-4575-8cb0-d2833ebf6783")

        # current selections
        self.cards = dict()

        # prepared statements

        self.get_cards_stmt = self.session.prepare(
            """
            SELECT card_id, set_id, is_deleted, card_question, card_answer, updated_at, created_at
            FROM card.card
            WHERE set_id = ?;
            """
        )

        self.update_card_stmt = self.session.prepare(
            """
            UPDATE card.card
            SET card_question = ?, card_answer = ?, updated_at = TOTIMESTAMP(NOW())
            WHERE set_id = ? AND card_id = ?;
            """
        )

        # self.get_sets_stmt = self.session.prepare(
        #     """
        #     SELECT set_id, title, is_deleted, updated_at, created_at
        #     FROM card.cardset
        #     WHERE user_id = ?;
        #     """,
        #     self.user.id,
        # )

    def get_cards(self):
        rows: ResultSet = self.session.execute(self.get_cards_stmt, [self.set_id])
        self.cards = [Card(*row) for row in rows]
        # self.cards = {c.id : c for c in cards}
        return self.cards

    # User functions

    def login(self):
        pass

    def register(self):
        pass

    def get_cardsets(self):
        pass

    # Card functions

    def add_card(self):
        pass

    def delete_card(self):
        pass

    def update_card(self, index: int):
        card = self.cards[index]
        self.session.execute(
            self.update_card_stmt, [card.question, card.answer, card.set_id, card.card_id]
        )

    def getCluster(self):
        profile = ExecutionProfile(
            load_balancing_policy=TokenAwarePolicy(
                DCAwareRoundRobinPolicy(local_dc="AWS_US_WEST_2")
            )
        )

        return Cluster(
            execution_profiles={EXEC_PROFILE_DEFAULT: profile},
            contact_points=[
                "node-0.aws-us-west-2.ecc4a1e8fd8134aef4bc.clusters.scylla.cloud",
                "node-1.aws-us-west-2.ecc4a1e8fd8134aef4bc.clusters.scylla.cloud",
                "node-2.aws-us-west-2.ecc4a1e8fd8134aef4bc.clusters.scylla.cloud",
            ],
            port=9042,
            auth_provider=PlainTextAuthProvider(
                username="scylla", password="FS2kjCvz7bLW0Nq"
            ),
        )


# def init():
#     cluster = getCluster()
#     session = cluster.connect("card")  # connect to 'card' keyspace

#     global card_stmt
#     card_stmt = session.prepare("SELECT card_question, card_answer FROM card")

#     return session
