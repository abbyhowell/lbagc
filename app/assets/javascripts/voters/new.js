function validate()
{
    var found_error = false;
    if(!$('#voter_voter_survey_attributes_has_attended_luna_burn').is(':checked')){
      alert("You must have attended Luna Burn at least once to be on the voting committee.");
      found_error = true;
    }
    if(!$('#voter_voter_survey_attributes_not_applying_this_year').is(':checked')){
      alert("You cannot be applying for an art grant this year to be on the voting committee");
      found_error = true;
    }
    if(!$('#voter_voter_survey_attributes_will_read').is(':checked')){
      alert("You must commit to doing the reading to be on the voting committee.");
      found_error = true;
    }
    if(!$('#voter_voter_survey_attributes_signed_agreement').is(':checked')){
      alert("You must read and sign the ethics agreement to be on the voting committee.");
      found_error = true;
    }
    return found_error === false;
}