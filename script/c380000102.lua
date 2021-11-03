--Cyber Style
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={70095154,1546123}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.GetLP(tp)<=2000
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=math.floor((4000-Duel.GetLP(tp))/1000)
	if ct>ft then ct=ft end
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,70095154)
		local tc=g:GetFirst()
		if tc then
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_FREE_CHAIN)
			e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
			tc:RegisterEffect(e0)
			Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
			e0:Reset()
			--Cannot be tributed
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(3303)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			tc:RegisterEffect(e2)
			--Special summon locked to fusion while on the field
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetAbsoluteRange(tp,1,0)
			e3:SetTarget(s.limit)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			--Cannot attack with non-fusion while on the field
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetRange(LOCATION_MZONE)
			e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
			e4:SetTargetRange(LOCATION_MZONE,0)
			e4:SetTarget(s.limit)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
			--Cannot change position
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e5:SetReset(RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e5)
			--Lizard check
			local e6=aux.createContinuousLizardCheck(e:GetHandler(),LOCATION_MZONE,s.lizfilter)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e6)
			--ATK becomes 0
			local e7=Effect.CreateEffect(e:GetHandler())
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetCode(EFFECT_SET_ATTACK)
			e7:SetValue(0)
			e7:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e7)
		end
	end
	--Can only Special Summon "Cyber End Dragon" until the end of your opponent's next turn
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function s.limit(e,c)
	return not c:IsType(TYPE_FUSION)
end
function s.lizfilter(e,c)
	return not c:IsOriginalType(TYPE_FUSION)
end
function s.splimit(e,c)
	return not c:IsCode(1546123)
end
