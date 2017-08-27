--Septette for the Dead Princess
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
local m=37564221
local cm=_G["c"..m]
cm.Senya_name_with_sawawa=true
function cm.initial_effect(c)
	Senya.SawawaCommonEffect(c,2,true,false,false)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(37564221,1))
	e9:SetCategory(CATEGORY_POSITION)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetCountLimit(1,375642211)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTarget(cm.target)
	e9:SetOperation(cm.operation)
	c:RegisterEffect(e9)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(37564221,2))
	e6:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,375642212)
	e6:SetCondition(Senya.CheckNoExtra)
	e6:SetTarget(cm.target1)
	e6:SetOperation(cm.operation1)
	c:RegisterEffect(e6)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() and c:GetFlagEffect(37564221)==0 end
	c:RegisterFlagEffect(37564221,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(function(e,c)
		return c:IsFacedown() and c:IsLocation(LOCATION_MZONE)
	end)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	Duel.RegisterEffect(e2,tp)
end
function cm.rmfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsAbleToDeck() and c:IsFaceup()
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end