--Baggy Sleeves
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddPreDrawSkillProcedure(c,1,false,s.flipcon,s.flipop)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLE_DESTROYED)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
		e1:SetCondition(s.drcon)
		e1:SetOperation(s.drop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
end
function s.filter(c,tp)
	return c:GetPreviousLevelOnField()>=7 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return eg:IsExists(s.filter,1,nil,tp)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	--opd register
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>1 then return end
	--condition
	return Duel.GetCurrentChain()==0 and Duel.GetTurnPlayer()==tp
	and Duel.GetFlagEffect(ep,id)==1
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--draw 2
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(2)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,1)
	Duel.RegisterEffect(e1,tp)
end
