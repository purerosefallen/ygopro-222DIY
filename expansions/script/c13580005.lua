--怨冥界 巫妖
local m=13580005
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Summon With Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.scon)
	e1:SetOperation(cm.sop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(cm.drcon)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
	--To Hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
--Summon With Hand
function cm.sfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function cm.scon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:GetLevel()>4 and minc<=1 and Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_HAND,0,1,c)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_HAND,0,1,1,c)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
--Draw
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Draw(tp,1,REASON_EFFECT)
end
--To Hand
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_RELEASE)==REASON_RELEASE
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,0,LOCATION_GRAVE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(m,1))
	local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,0,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_RULE)
		Duel.ConfirmCards(1-tp,g)
	end
end