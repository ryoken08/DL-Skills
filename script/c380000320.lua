--I've Seen That Deck Before
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
function s.filter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,c:GetCode()),tp,0,LOCATION_MZONE,1,nil)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--three time per duel check
	if Duel.GetFlagEffect(ep,id)>2 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil,tp)
	local ct=g:GetClassCount(Card.GetCode)*500
	if #g==0 or ct==0 then return end
	local lp=Duel.GetLP(tp)+ct
	Duel.SetLP(tp, lp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
