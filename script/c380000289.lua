--Shell of a Ghost
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={66957584}
s.listed_series={0xb}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
	and not Duel.IsExistingMatchingCard(aux.NOT(Card.IsSetCard),tp,LOCATION_MZONE,0,1,nil,0xb)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,66957584)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local sg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,66957584):RandomSelect(tp,1)
		local tc=sg:GetFirst()
		if tc then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,SEQ_DECKTOP)
			Duel.ConfirmDecktop(tp,1)
		end
		Duel.BreakEffect()
	end
	local token=Duel.CreateToken(tp,66957584)
	Duel.SendtoDeck(token,nil,SEQ_DECKBOTTOM,REASON_RULE)
end
