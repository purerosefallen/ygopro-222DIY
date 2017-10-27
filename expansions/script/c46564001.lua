--苍 瀑 的 沫 愿 · 月 与 海
local m=46564001
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m) 
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--loven paly
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(cm.vcon)
	e0:SetOperation(cm.loven)
	c:RegisterEffect(e0)
	--to hand --delete
	--Special Summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(0x656)
	e3:SetCondition(cm.spcon)
	c:RegisterEffect(e3)
	--activate limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(cm.lmtcon)
	e4:SetOperation(cm.lmtop)
	c:RegisterEffect(e4)
	--pierce
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCost(cm.cost)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.chop)
	c:RegisterEffect(e5)
end
function cm.vcon(e)
	return bit.band(e:GetHandler():GetSummonType(),0x656)==0x656
end
function cm.loven(e,tp,eg)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,0))
end 
function cm.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_TUNER)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.lmtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function cm.lmtop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(cm.elimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.elimit(e,te,tp)
	return te:GetHandler():IsLocation(LOCATION_GRAVE)
end -------e4 actlmt finish
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.chfilter(c,e)
	return bit.band(c:GetSummonLocation(),LOCATION_EXTRA)~=0 and c:IsRace(RACE_FAIRY)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.chfilter,nil)
	local ct=g:GetCount()
	if chk==0 then return ct>0 end
	Duel.SetTargetCard(eg)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.chfilter,nil,e)
		for rc in aux.Next(g) do
		rc:IsRelateToEffect(e)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetReset(0x1fe1000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		rc:RegisterEffect(e1)
	end
end