--Bandit
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil)
	and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	and Duel.GetMatchingGroupCount(s.filter,tp,0,LOCATION_SZONE,nil)>0
	and Duel.GetLP(tp)<=1500
end
function s.filter(c)
	return c:IsFacedown() and c:IsAbleToChangeControler() and not c:IsType(TYPE_FIELD)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
	end
	local g1=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_SZONE,nil)
	Duel.ConfirmCards(tp,g1)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
end
