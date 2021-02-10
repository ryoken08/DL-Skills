--You Don't Deserve to Exist in My World
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.filter(c,tp)
	return c:GetEquipCount()>0 and c:GetEquipGroup():IsExists(Card.IsControler,1,nil,1-tp) 
		and (c:GetAttack()-c:GetBaseAttack())>=1000
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil,tp)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if tc then
		tc:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
		Duel.SendtoDeck(tc,nil,-2,REASON_RULE)
	end
end
