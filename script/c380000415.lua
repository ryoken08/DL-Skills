--Extra Balloons
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.listed_names={78574395}
s.counter_place_list={0x32}
s.filter=aux.FilterFaceupFunction(Card.IsCode,78574395)
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_SZONE,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--Select 1 "Wonder Balloons" on your field
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.HintSelection(g)
	--Place 1 Balloon Counter
	local tc=g:GetFirst()
	tc:AddCounter(0x32,1)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
