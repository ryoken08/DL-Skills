--Magic Combo
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
	aux.GlobalCheck(s,function()
		s[0]=false
		s[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		aux.AddValuesReset(function()
			s[0]=false
			s[1]=false
		end)
	end)
end
s.listed_names={51254277,7653207}
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsCode(51254277) then
		s[rp]=true
	end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--twice per duel check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	return aux.CanActivateSkill(tp) and s[tp]
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
