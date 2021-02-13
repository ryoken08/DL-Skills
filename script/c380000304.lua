--Magic Combo
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SUMMON,s.counterfilter)
end
s.listed_names={51254277,7653207}
function s.counterfilter(c)
	return not c:IsCode(51254277)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SUMMON)>0
	and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,7653207)
	and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--flag register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local tc=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,nil,7653207)
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	end
end
