--Surprise Present
--Effect is not fully implemented
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
	and Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_SZONE,0,nil)>0
end
function s.filter(c)
	return c:IsFacedown() and c:IsAbleToChangeControler() and not c:IsType(TYPE_FIELD)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_SZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,true)
	end
end
