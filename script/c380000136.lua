--Level Reduction
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(s.lvfilter,tp,LOCATION_HAND,0,1,nil)
	and Duel.GetLP(tp)<=3000
end
function s.cfilter(c)
	return c:IsLevelAbove(1) and c:IsFaceup()
end
function s.lvfilter(c)
	return c:IsLevelAbove(1) and not c:IsPublic()
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,s.lvfilter,tp,LOCATION_HAND,0,1,1,nil)
	local g1=sg:GetFirst()
	if g1 then
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleHand(tp)
	end
	local lv=g1:GetLevel()
	if tc then
		tc:UpdateLevel(-lv,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,e:GetHandler())
	end
end
