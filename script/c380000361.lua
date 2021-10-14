--Parts Replacement [Wisel]
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={100000051,100000052,100000053}
s.filter=aux.FilterFaceupFunction(Card.IsOriginalCodeRule,100000051,100000052,100000053)
s.list={[100000051]=100000049,[100000052]=100000048,[100000053]=100000047}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if tc then
		local code=tc:GetCode()
		local tcode=s.list[code]
		--transform
		tc:Recreate(tcode,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
	end
end
