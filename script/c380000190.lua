--One with the Dinos
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.GetTurnCount()>=3
end
function s.filter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsLevelAbove(7) and c:IsFaceup()
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g)
	local tc=sg:GetFirst()
	if tc then
		--ATK/DEF becomes equal to your Life Points
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(Duel.GetLP(e:GetOwnerPlayer()))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e2)
		--lose if it leaves the field
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetLabel(1-tp)
		e3:SetOperation(s.leaveop)
		e3:SetReset(RESET_EVENT+RESET_OVERLAY+RESET_MSCHANGE+RESET_TURN_SET)
		tc:RegisterEffect(e3,true)
	end
end
function s.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_ONE_WITH_THE_DINOS=0x26
	Duel.Win(e:GetLabel(),WIN_REASON_ONE_WITH_THE_DINOS)
end
