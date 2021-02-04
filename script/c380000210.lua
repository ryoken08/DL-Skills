--Immortal Charity
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x21),tp,LOCATION_MZONE,0,1,nil)
end
s.cards = {
	96907086, 29934351, 56339050
}
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local token=Duel.CreateToken(tp,s.cards[Duel.GetRandomNumber(1,3)])
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
	token:SetStatus(STATUS_SET_TURN,true)
end
