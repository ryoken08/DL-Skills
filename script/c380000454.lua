--Fortissimo Combo!
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.listed_series={0x3013}
s.listed_names={86997073}
function s.filter(c)
	return c:IsMonster() and c:IsSetCard(0x3013)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Return 1 "Meklord Emperor" monster in your hand to your Deck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
	--If there already is Field Spell on your side of the field, return it to your hand
	local sg=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if sg then
		Duel.SendtoHand(sg,nil,REASON_RULE)
	end
	--play 1 face-up "Fortissimo the Mobile Fortress" to your field from outside of the Deck
	local token=Duel.CreateToken(tp,86997073)   
	Duel.MoveToField(token,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
end
