--ＰＭ 巨牙鲨
function c80000482.initial_effect(c)
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c80000482.hspcon)
	e1:SetOperation(c80000482.hspop)
	c:RegisterEffect(e1)   
	--Attribute Dark
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2) 
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000482,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetTarget(c80000482.destg1)
	e3:SetOperation(c80000482.desop1)
	c:RegisterEffect(e3)
end
function c80000482.hspfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) 
end
function c80000482.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),c80000482.hspfilter,1,nil)
end
function c80000482.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c80000482.hspfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c80000482.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsFaceup() and tc:GetAttribute()~=ATTRIBUTE_WATER end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c80000482.tgfilter(c)
	return c:IsSetCard(0x2d0) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToGrave()
end
function c80000482.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c80000482.tgfilter,p,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(p,aux.Stringid(80000482,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end