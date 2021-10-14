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
		local code=tc:GetCode()
		local tcode=s.list[code]
		tc:Recreate(tcode,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
	end
end
