from sqlalchemy import Column, Integer, String, Boolean
from sqlalchemy.ext.declarative import declarative_base
# Create a base class for declarative class definitions
Base = declarative_base()


# Define the table
class Price(Base):
    __tablename__ = 'price'
    __table_args__ = {"schema": "schema_dsad"}

    first_name = Column(String(50), primary_key=True)
    last_name = Column(String(50), primary_key=True)
    price = Column(Integer, primary_key=True)
    above_100 = Column(Boolean, primary_key=False)

