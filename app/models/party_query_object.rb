class PartyQueryObject
  extend QueryObject

  def self.all
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
        ?party a parl:Party ;
                parl:partyName ?partyName .
      }
      WHERE {
	      ?party a parl:Party ;
                parl:partyName ?partyName .
      }
    ')
  end

  def self.all_current
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?party a parl:Party ;
            	parl:partyName ?partyName .
      }
      WHERE {
      	?seatIncumbency a parl:SeatIncumbency .
        FILTER NOT EXISTS { ?seatIncumbency a parl:PastSeatIncumbency . }
        ?seatIncumbency parl:seatIncumbencyHasMember ?person .
        ?person parl:partyMemberHasPartyMembership ?partyMembership .
        FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
        ?partyMembership parl:partyMembershipHasParty ?party .
        ?party parl:partyName ?partyName .
      }
    ')
  end

  def self.all_by_letter(letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?party
           a parl:Party ;
           parl:partyName ?partyName .
      }
      WHERE {
        ?party a parl:Party ;
              parl:partyName ?partyName .
        FILTER regex(str(?partyName), \"^#{letter.upcase}\") .
      }
    ")
  end

  def self.find(id)
    self.uri_builder("
     PREFIX parl: <http://id.ukpds.org/schema/>
     CONSTRUCT {
	      ?party a parl:Party;
               parl:partyName ?name
     }
     WHERE {
	      ?party parl:partyName ?name

        FILTER (?party = <#{DATA_URI_PREFIX}/#{id}> )
      }
    ")
  end

  def self.members(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?party a parl:Party ;
            parl:partyName ?partyName .
        ?person a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName .
        ?partyMembership a parl:PartyMembership ;
            parl:partyMembershipStartDate ?startDate ;
            parl:partyMembershipEndDate ?endDate ;
            parl:partyMembershipHasPartyMember ?person .
      }
      WHERE {
      	?party parl:partyName ?partyName ;
          		parl:partyHasPartyMembership ?partyMembership .
        ?partyMembership parl:partyMembershipHasPartyMember ?person .
        ?partyMembership parl:partyMembershipStartDate ?startDate .
        OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?endDate . }

        OPTIONAL { ?person parl:personGivenName ?givenName . }
        OPTIONAL { ?person parl:personFamilyName ?familyName . }

      	FILTER (?party = <#{DATA_URI_PREFIX}/#{id}> )
      }
    ")
  end

  def self.members_by_letter(id, letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?party a parl:Party ;
            parl:partyName ?partyName .
        ?person a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName .
        ?partyMembership a parl:PartyMembership ;
            parl:partyMembershipStartDate ?startDate ;
            parl:partyMembershipEndDate ?endDate ;
            parl:partyMembershipHasPartyMember ?person .
      }
      WHERE {
      	?party parl:partyName ?partyName ;
          		parl:partyHasPartyMembership ?partyMembership .
        ?partyMembership parl:partyMembershipHasPartyMember ?person .
        ?partyMembership parl:partyMembershipStartDate ?startDate .
        OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?endDate . }

        OPTIONAL { ?person parl:personGivenName ?givenName . }
        OPTIONAL { ?person parl:personFamilyName ?familyName . }

      	FILTER (?party = <#{DATA_URI_PREFIX}/#{id}> )
        FILTER regex(str(?familyName), \"^#{letter.upcase}\") .
      }
    ")
  end

  # TODO: Once the full data is populated run this query to check number of party memberships is correct

  def self.current_members(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?party a parl:Party ;
            parl:partyName ?partyName .
        ?person a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName .
        ?partyMembership a parl:PartyMembership ;
            parl:partyMembershipStartDate ?startDate ;
            parl:partyMembershipHasPartyMember ?person .
      }
      WHERE {
      	?party parl:partyName ?partyName ;
          		parl:partyHasPartyMembership ?partyMembership .
        FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
        ?partyMembership parl:partyMembershipHasPartyMember ?person .
        ?partyMembership parl:partyMembershipStartDate ?startDate .

        OPTIONAL { ?person parl:personGivenName ?givenName . }
        OPTIONAL { ?person parl:personFamilyName ?familyName . }

      	FILTER (?party = <#{DATA_URI_PREFIX}/#{id}> )
      }
      ")
  end

  def self.current_members_by_letter(id, letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?party a parl:Party ;
            parl:partyName ?partyName .
        ?person a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName .
        ?partyMembership a parl:PartyMembership ;
            parl:partyMembershipStartDate ?startDate ;
            parl:partyMembershipHasPartyMember ?person .
      }
      WHERE {
      	?party parl:partyName ?partyName ;
          		 parl:partyHasPartyMembership ?partyMembership .
        FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
        ?partyMembership parl:partyMembershipHasPartyMember ?person .
        ?partyMembership parl:partyMembershipStartDate ?startDate .

        OPTIONAL { ?person parl:personGivenName ?givenName . }
        OPTIONAL { ?person parl:personFamilyName ?familyName . }

        FILTER (?party = <#{DATA_URI_PREFIX}/#{id}> )
        FILTER regex(str(?familyName), \"^#{letter.upcase}\") .
       }
     ")
  end

end