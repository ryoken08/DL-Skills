--Master of Destiny
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddSkillProcedure(c,1,false)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetCondition(s.flipcon)
	e1:SetOperation(s.flipop)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c.toss_coin and not c:IsType(TYPE_SKILL)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetCode)>=7
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--coin toss
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_TOSS_COIN_CHOOSE)
	e1:SetCondition(s.repcon)
	e1:SetOperation(s.repop(Duel.GetCoinResult,Duel.SetCoinResult))
	Duel.RegisterEffect(e1,tp)
	--skip next draw
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_SKIP_DP)
	e2:SetTargetRange(1,0)
	if Duel.GetTurnPlayer()==tp and not Duel.IsDuelType(DUEL_1ST_TURN_DRAW) then
		e2:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,2)
	else
		e2:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	end
	Duel.RegisterEffect(e2,tp)
end
function s.repcon(e,tp,eg,ep,ev,re,r,rp)
	--flag check
	if Duel.GetFlagEffect(ep,id)>2 then return end
	return ep==tp
end
function s.repop(func1,func2)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local dc={func1()}
		local ct=(ev&0xff)+(ev>>16)
		local res=1
		if ct>1 then
			local tab={}
			for i=1,ct do
				if Duel.GetFlagEffect(ep,id)<3 then
					dc[i]=res
					--flag register
					Duel.RegisterFlagEffect(ep,id,0,0,0)
				else
					dc[i]=Duel.GetRandomNumber(1,2)
				end
			end
		else
			dc[1]=res
			--flag register
			Duel.RegisterFlagEffect(ep,id,0,0,0)
		end
		func2(table.unpack(dc))
	end
end
