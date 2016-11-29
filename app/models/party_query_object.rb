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
                    FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
                    OPTIONAL { ?partyMembership parl:partyMembershipHasParty ?party . }
                    OPTIONAL { ?party parl:partyName ?partyName . }
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

  def self.members(id)
    self.query("
                PREFIX parl: <http://id.ukpds.org/schema/>
                PREFIX : <http://www.ontotext.com/plugins/geosparql#>
                CONSTRUCT {
                   ?member a parl:Member ;
                           parl:forename ?forename ;
                           parl:middleName ?middleName ;
                           parl:surname ?surname .
     					_:x
                           parl:connect ?partyMembershipStartDate ;
        				   parl:connect ?partyMembershipEndDate ;
       					   parl:connect ?member .
                }
                WHERE {
                    ?party parl:partyHasPartyMembership ?partyMembership .
    				        ?partyMembership parl:partyMembershipHasPerson ?member .
                    OPTIONAL { ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate . }
        			      OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }
                    ?member
                          a parl:Member .
                          OPTIONAL { ?member parl:forename ?forename } .
                          OPTIONAL { ?member parl:middleName ?middleName } .
                          OPTIONAL { ?member parl:surname ?surname } .
                    FILTER (?party = <#{DATA_URI_PREFIX}/#{id}> )
                }
               ")
  end

  def self.current_members(id)
    self.query("
                PREFIX parl: <http://id.ukpds.org/schema/>
                CONSTRUCT {
                   ?member a parl:Member ;
                           parl:forename ?forename ;
                           parl:middleName ?middleName ;
                           parl:surname ?surname ;
                           parl:partyMembershipStartDate ?partyMembershipStartDate .
                }

                WHERE {
                    ?party parl:partyHasPartyMembership ?partyMembership .
                    FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
                    ?partyMembership parl:partyMembershipHasPerson ?member .
                    OPTIONAL { ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate . }
                    ?member
                          a parl:Member .
                            OPTIONAL { ?member parl:forename ?forename } .
                            OPTIONAL { ?member parl:middleName ?middleName } .
                            OPTIONAL { ?member parl:surname ?surname } .
                    FILTER (?party = <#{DATA_URI_PREFIX}/#{id}> )
                }
               ")
  end

end