--初恋·Misaki
local m=98600001
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddFusionProcFunRep(c,cm.mfilter,3,true)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,1)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.discon)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(0x14000)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,1)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ex=Effect.GlobalEffect()
		ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ex:SetCode(EVENT_TO_GRAVE)
		ex:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and eg:IsContains(re:GetHandler())
		end)
		ex:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			re:GetHandler():RegisterFlagEffect(m,0x1fe1000,0,1)
		end)
		Duel.RegisterEffect(ex,0)
	end
end
function cm.mfilter(c)
	return c:IsType(TYPE_TUNER) and c:GetLevel()==3 and c:GetAttack()==0 and c:GetDefense()==1800
end
function cm.spfilter1(c,fc)
	return cm.mfilter(c) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost() and c:GetFlagEffect(m)>0
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_GRAVE,0,3,nil,c)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_GRAVE,0,3,3,nil,c)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_FUSION+REASON_MATERIAL+REASON_COST)
end
function cm.cfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsAbleToDeckAsCost() and c:IsFaceup()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,np=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CONTROLER)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and bit.band(loc,0x0c)~=0 and np~=tp
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0) end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,1-tp,LOCATION_EXTRA)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	local tg=g:Filter(Card.IsAbleToRemove,nil)
	if tg:GetCount()>=3 then
		Duel.ConfirmCards(tp,g)
		local rg=tg:Select(tp,3,3,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end