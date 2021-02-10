--Gathering of Disciples
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={CARD_DARK_MAGICIAN,CARD_DARK_MAGICIAN_GIRL}
function s.filter(c)
	return c:IsCode(CARD_DARK_MAGICIAN) and not c:IsPublic()
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--reveal 1 dark magician
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
	end
	--add 1 dark magician girl
	local token=Duel.CreateToken(tp,CARD_DARK_MAGICIAN_GIRL)
	if Duel.GetLP(tp)<=2500 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.SendtoHand(token,nil,REASON_RULE)
	else
		Duel.SendtoDeck(token,nil,SEQ_DECKBOTTOM,REASON_RULE)
	end
end
