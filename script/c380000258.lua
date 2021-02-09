--Time Roulette Go!
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
	aux.GlobalCheck(s,function()
		s[0]=false
		s[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CUSTOM+71625222)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		aux.AddValuesReset(function()
			s[0]=false
			s[1]=false
		end)
	end)
end
s.listed_names={71625222,CARD_DARK_MAGICIAN,92377303,88819587,41462083}
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		s[0]=true
	end
	if ep==1-tp then
		s[1]=true
	end
end
function s.filter(c)
	return c:IsFaceup() and c:IsOriginalCodeRule(CARD_DARK_MAGICIAN,88819587)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp) and s[tp]
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
s.list={[CARD_DARK_MAGICIAN]=92377303,[88819587]=41462083}
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local seq=tc:GetSequence()
		local pos=tc:GetPosition()
		local code=tc:GetCode()
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
