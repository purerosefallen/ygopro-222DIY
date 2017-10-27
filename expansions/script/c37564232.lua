--Crimson Beat
local m=37564232
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_sawawa=true
function cm.initial_effect(c)
	--Senya.setreg(c,m,37564299)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(function(e,c)
		return c:GetSummonLocation()==LOCATION_EXTRA
	end)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
function cm.spfilter(c)
	return c:IsType(TYPE_MONSTER) and Senya.check_set_sawawa(c) and c:IsAbleToGraveAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetMZoneCount(c:GetControler())>0
		and Duel.IsExistingMatchingCard(cm.spfilter,c:GetControler(),LOCATION_HAND,0,3,c) and Senya.CheckNoExtra(e,c:GetControler())
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,3,3,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.filter(c)
	return c:IsAbleToGrave()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetHandler():GetFlagEffect(60151298)>0 then
		if chk==0 then return true end
		Duel.SetChainLimit(aux.FALSE)
	else
		if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_ONFIELD,1,nil) end
		local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,0,0,0)
		Duel.SetChainLimit(aux.FALSE)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,0,LOCATION_ONFIELD,1,2,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if e:GetHandler():GetFlagEffect(60151298)>0 then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,2))
			Duel.Hint(HINT_CARD,0,m)
			Duel.SendtoGrave(g,REASON_RULE)
		else
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end