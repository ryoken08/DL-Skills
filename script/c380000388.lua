--Re-Atlandis
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={9161357}
s.listed_series={0x48}
function s.filter(c,tp)
	return c:IsSetCard(0x48) and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function s.eqfilter(c,ec,tp)
	local eff={c:GetCardEffect(89785779)}
	if c:IsFacedown() or not c:IsCode(9161357) then return false end
	for _,te in ipairs(eff) do
		if te:GetValue()(ec,c,tp) then return true end
	end
	return false
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil,tp)
	and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tc,tp)
	local tc2=sg:GetFirst()
	if not tc2 then return end
	local te=tc2:GetCardEffect(89785779)
	if tc then
		te:GetOperation()(tc2,te:GetLabelObject(),tp,tc)
	end
end
