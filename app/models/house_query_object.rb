class HouseQueryObject
  extend QueryObject

  def self.all
    self.query('
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
          ?house a parl:House .
      }
      WHERE {
          ?house a parl:House .
      }'
    )
  end

  def self.find(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
          ?house a parl:House .
      }
      WHERE {
          ?house a parl:House .

          FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
      }")
  end

  def self.members(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
          ?member a parl:Member ;
                  parl:forename ?forename ;
              	  parl:surname ?surname .
      }
      WHERE {
      	?house parl:houseHasSeat ?seat.
        ?seat parl:seatHasSitting ?sitting .
        ?sitting parl:sittingHasPerson ?member .
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:surname ?surname . }

        FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.members_by_letter(id, letter)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
          ?member a parl:Member ;
                  parl:forename ?forename ;
              	  parl:surname ?surname .
      }
      WHERE {
      	?house parl:houseHasSeat ?seat.
        ?seat parl:seatHasSitting ?sitting .
        ?sitting parl:sittingHasPerson ?member .
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:surname ?surname . }

        FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
        FILTER regex(str(?surname), \"^#{letter.upcase}\") .
      }
    ")
  end

  def self.current_members(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
          ?member a parl:Member ;
                  parl:forename ?forename ;
                  parl:surname ?surname .
          _:x parl:sittingStartDate ?sittingStartDate ;
              parl:connect ?member ;
              parl:objectId ?sitting .
      }
      WHERE {
      	?house parl:houseHasSeat ?seat.
        ?seat parl:seatHasSitting ?sitting .
        ?sitting parl:sittingHasPerson ?member .
        FILTER NOT EXISTS { ?sitting a parl:PastSitting . }
        OPTIONAL { ?sitting parl:startDate ?sittingStartDate . }
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:surname ?surname . }

        FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
      }
    ")
  end

  def self.current_members_by_letter(id, letter)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
          ?member a parl:Member ;
                  parl:forename ?forename ;
                  parl:surname ?surname .
          _:x parl:sittingStartDate ?sittingStartDate ;
              parl:connect ?member ;
              parl:objectId ?sitting .
      }
      WHERE {
      	?house parl:houseHasSeat ?seat.
        ?seat parl:seatHasSitting ?sitting .
        ?sitting parl:sittingHasPerson ?member .
        FILTER NOT EXISTS { ?sitting a parl:PastSitting . }
        OPTIONAL { ?sitting parl:startDate ?sittingStartDate . }
        OPTIONAL { ?member parl:forename ?forename . }
        OPTIONAL { ?member parl:surname ?surname . }

        FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
        FILTER regex(str(?surname), \"^#{letter.upcase}\") .
      }
    ")
  end

  def self.parties(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?party parl:partyName ?partyName .
      }
      WHERE {
        SELECT DISTINCT ?party ?partyName
          WHERE {
            ?house parl:houseHasSeat ?seat.
            ?seat parl:seatHasSitting ?sitting .
            ?sitting parl:sittingHasPerson ?member .
            ?member parl:personHasPartyMembership ?partyMembership .
            ?partyMembership parl:partyMembershipHasParty ?party .
            ?party parl:partyName ?partyName .

            FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
          }
        }
     ")
  end

  def self.current_parties(id)
    self.query("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?party parl:partyName ?partyName .
      }
      WHERE {
        SELECT DISTINCT ?party ?partyName
          WHERE {
            ?house parl:houseHasSeat ?seat.
            ?seat parl:seatHasSitting ?sitting .
              FILTER NOT EXISTS { ?sitting a parl:PastThing . }
            ?sitting parl:sittingHasPerson ?member .
            ?member parl:personHasPartyMembership ?partyMembership .
              FILTER NOT EXISTS { ?partyMembership a parl:PastThing . }
            ?partyMembership parl:partyMembershipHasParty ?party .
            ?party parl:partyName ?partyName .

            FILTER(?house = <#{DATA_URI_PREFIX}/#{id}>)
          }
        }
     ")
  end
end
