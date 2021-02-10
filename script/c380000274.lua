--Spell Counter Boost
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.counter_place_list={COUNTER_SPELL}
function s.filter(c)
	return c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function s.cfilter(c)
	return c:IsCanAddCounter(COUNTER_SPELL,1) and c:IsFaceup()
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,2,nil)
	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--reveal 2 spell cards
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,2,2,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	--add 1 spell counter
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(73853830,1))
	local sg=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=sg:GetFirst()
	if tc then
		tc:AddCounter(COUNTER_SPELL,1)
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
