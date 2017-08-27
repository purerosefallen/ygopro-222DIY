--Nanahira & Hanekoi
local m=37564533
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT),true)
	Senya.AddSelfFusionProcedure(c,LOCATION_MZONE,Duel.Release)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,0))
			e1:SetCategory(CATEGORY_REMOVE)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e1:SetCode(EVENT_BATTLED)
			e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_AVAILABLE_BD)
			e1:SetCondition(cm.rmcon)
			e1:SetTarget(cm.rmtg)
			e1:SetOperation(cm.rmop)
			c:RegisterEffect(e1)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return bc and bc:IsStatus(STATUS_OPPO_BATTLE) and bc:IsRelateToBattle()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabelObject():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetLabelObject(),1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() and bc:IsControler(1-tp)  then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end