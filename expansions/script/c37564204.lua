--Sawawa-Pattern Fire
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
local m=37564204
local cm=_G["c"..m]
cm.Senya_name_with_sawawa=true
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37564204,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(Senya.CheckNoExtra)
	e2:SetCost(Senya.SawawaRemoveCost(1))
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
	Senya.SawawaCommonEffect(c,1,true,false,false)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local se=Duel.SelectOption(tp,aux.Stringid(37564204,2),aux.Stringid(37564204,3))
	if se==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetTarget(cm.rmtg)
		e1:SetTargetRange(0,0xff)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if se==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_REMOVE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		--30459350 chk
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(30459350)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(0,1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end