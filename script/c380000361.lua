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
		local seq=tc:GetSequence()
		local pos=tc:GetPosition()
		local code=tc:GetCode()
		tc:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
		Duel.SendtoDeck(tc,nil,-2,REASON_RULE)
		local tcode=s.list[code]
		local token=Duel.CreateToken(tp,tcode)
		--transform
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
		token:RegisterEffect(e0)
		Duel.MoveToField(token,tp,tp,LOCATION_MZONE,pos,true,(1<<seq))
		e0:Reset()
	end
end
