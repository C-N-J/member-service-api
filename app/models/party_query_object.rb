class PartyQueryObject
  extend QueryObject

  def self.all
    self.query('
              PREFIX parl: <http://id.ukpds.org/schema/>
              CONSTRUCT {
                 ?party parl:partyName ?partyName .
              }

              WHERE {
                  ?party a parl:Party ;
                  OPTIONAL{ ?party parl:partyName ?partyName . }
              }'
    )
  end

  def self.all_current
    self.query('
                PREFIX parl: <http://id.ukpds.org/schema/>
                CONSTRUCT {
                   ?party parl:partyName ?partyName .
                }

                WHERE {
                    ?partyMembership a parl:PartyMembership .
                    MINUS { ?partyMembership a parl:PastPartyMembership . }
                    ?partyMembeship parl:partyMembershipHasParty ?party .
                    ?party parl:partyName ?partyName .
                }
               ')
  end

  def self.find(id)
    self.query("
              PREFIX parl: <http://id.ukpds.org/schema/>
              CONSTRUCT {
                 ?party parl:partyName ?partyName .
              }

              WHERE {
                  ?party parl:partyName ?partyName .
                  FILTER (?party = <#{DATA_URI_PREFIX}/#{id}> )
              }
    ")
  end

  def self.all_members(id)
    self.query("
                PREFIX parl: <http://id.ukpds.org/schema/>
                CONSTRUCT {
                   ?member
                           parl:forename ?forename ;
                           parl:middleName ?middleName ;
                           parl:surname ?surname ;
                }

                WHERE {
                    ?party parl:partyHasPartyMembership ?partyMembership .
                    ?partyMembership parl:partyMembershipHasPerson ?member .
                    ?member
                          a parl:Member .
                    ?member parl:personHasSitting ?sitting .
                            OPTIONAL { ?member parl:forename ?forename } .
                            OPTIONAL { ?member parl:middleName ?middleName } .
                            OPTIONAL { ?member parl:surname ?surname } .
                    FILTER (?party = <#{DATA_URI_PREFIX}/#{id}> )
                }
               ")
  end

  def self.all_current_members(id)
    self.query("
                PREFIX parl: <http://id.ukpds.org/schema/>
                CONSTRUCT {
                   ?member
                           parl:forename ?forename ;
                           parl:middleName ?middleName ;
                           parl:surname ?surname ;
                }

                WHERE {
                    ?party parl:partyHasPartyMembership ?partyMembership .
                    FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
                    ?partyMembership parl:partyMembershipHasPerson ?member .
                    ?member
                          a parl:Member .
                    ?member parl:personHasSitting ?sitting .
                    FILTER NOT EXISTS { ?sitting a parl:PastSitting . }
                            OPTIONAL { ?member parl:forename ?forename } .
                            OPTIONAL { ?member parl:middleName ?middleName } .
                            OPTIONAL { ?member parl:surname ?surname } .
                    FILTER (?party = <#{DATA_URI_PREFIX}/#{id}> )
                }
               ")
  end

end