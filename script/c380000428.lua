--Blowing Up Yosen
--Effect is not fully implemented
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={27918963}
s.listed_series={0xb3}
s.counter_place_list={0x33}
s.filter=aux.FilterFaceupFunction(Card.IsCode,27918963)
function s.cfilter(c)
	return c:IsFaceup() and c:IsMonster() and c:IsSetCard(0xb3)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Select 1 "Yosen Training Grounds" you control
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.HintSelection(g)
	--Place Yosen Counter(s) equal to the number of "Yosenju" monsters on your field
	local tc=g:GetFirst()
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_MZONE,0,nil)
	tc:AddCounter(0x33,ct)
end
