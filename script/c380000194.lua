--Right Side Up!
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
	e1:SetOperation(s.flipop)
	c:RegisterEffect(e1)
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
end
function s.repcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x5) and rc:IsType(TYPE_MONSTER) and ep==tp
end
function s.repop(func1,func2)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local dc={func1()}
		local ct=(ev&0xff)+(ev>>16)
		local res=1
		if ct>1 then
			local tab={}
			for i=1,ct do
				dc[i]=res
			end
		else
			dc[1]=res
		end
		func2(table.unpack(dc))
	end
end
