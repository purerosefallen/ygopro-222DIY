--Sawawa-Lunatic Sprinter
local m=37564205
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_sawawa=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(0x14000)
	e1:SetCondition(Senya.CheckNoExtra)
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	Senya.SawawaCommonEffect(c,1,true,false,false)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function cm.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_EXTRA,nil)
	if g:GetCount()==0 then return end
	local gc=g:RandomSelect(tp,1):GetFirst()
	Duel.Remove(gc,POS_FACEUP,REASON_EFFECT)
		local tc=Duel.GetOperatedGroup():GetFirst()
		Senya.CopyStatusAndEffect(e,nil,tc)
end