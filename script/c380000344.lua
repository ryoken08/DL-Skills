--Dice of Orgoth the Relentless
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
	Duel.AddCustomActivityCounter(id,ACTIVITY_SUMMON,s.counterfilter)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
s.listed_names={15744417}
function s.counterfilter(c)
	return not c:IsCode(15744417)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local token=Duel.CreateToken(tp,15744417)
	Duel.SendtoDeck(token,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	--dice toss
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_TOSS_DICE_CHOOSE)
	e1:SetCondition(s.repcon)
	e1:SetOperation(s.repop(Duel.GetDiceResult,Duel.SetDiceResult))
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
function s.repcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	return ep==tp and (Duel.GetCustomActivityCount(id,tp,ACTIVITY_SUMMON)>0 or Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)>0)
end
function s.repop(func1,func2)
	return function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		local dc={func1()}
		local ct=(ev&0xff)+(ev>>16)
		local res=6
		if ct>1 then
			local tab={}
			for i=1,ct do
				if Duel.GetFlagEffect(ep,id)<1 then
					dc[i]=res
					--opd register
					Duel.RegisterFlagEffect(ep,id,0,0,0)
				else
					dc[i]=Duel.GetRandomNumber(1,6)
				end
			end
		else
			dc[1]=res
			--opd register
			Duel.RegisterFlagEffect(ep,id,0,0,0)
		end
		func2(table.unpack(dc))
	end
end
