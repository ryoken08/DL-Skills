--Majestic Light
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.listed_names={21159309}
function s.filter(c)
	return c:IsType(TYPE_TUNER)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,21159309)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		Duel.BreakEffect()
	end
	local tc=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,nil,21159309)
	if tc then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
		tc:RegisterEffect(e0)
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		e0:Reset()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
