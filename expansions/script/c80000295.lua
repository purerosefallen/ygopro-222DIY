--传说中的口袋妖怪 炎帝
function c80000295.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c80000295.xyzcon)
	e1:SetOperation(c80000295.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--wudi 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c80000295.efilter)
	c:RegisterEffect(e2)   
	--destroy2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000295,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c80000295.cost2)
	e3:SetTarget(c80000295.target2)
	e3:SetOperation(c80000295.operation2)
	c:RegisterEffect(e3)
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(c80000295.splimit)
	c:RegisterEffect(e4)   
	--handes
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80000295,0))
	e5:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetCondition(c80000295.condition)
	e5:SetTarget(c80000295.target)
	e5:SetOperation(c80000295.operation)
	c:RegisterEffect(e5)
	--spsummon limit
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	e8:SetValue(c80000295.splimit)
	c:RegisterEffect(e8)
	if not c80000295.xyz_filter then
		c80000295.xyz_filter=function(mc) return mc:IsType(TYPE_XYZ) and mc:IsSetCard(0x2d0) and mc:IsAttribute(ATTRIBUTE_FIRE) and mc:IsCanBeXyzMaterial(c) end
	end
end   
function c80000295.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and not (se:GetHandler():IsType(TYPE_SPELL) or se:GetHandler():IsType(TYPE_MONSTER) or se:GetHandler():IsType(TYPE_TRAP))
end 
function c80000295.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x2d0) and c:GetOverlayCount()>0 and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeXyzMaterial(xyzc)
end
function c80000295.xyzfilter1(c,g,ct)
	return g:IsExists(c80000295.xyzfilter2,ct,c,c:GetRank())
end
function c80000295.xyzfilter2(c,rk)
	return c:GetRank()==rk
end
function c80000295.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=3
	local maxc=64
	if min then
		minc=math.max(minc,min)
		maxc=max
	end
	local ct=math.max(minc-1,-ft)
	local mg=nil
	if og then
		mg=og:Filter(c80000295.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c80000295.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	return maxc>=3 and mg:IsExists(c80000295.xyzfilter1,1,nil,mg,ct)
end
function c80000295.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		local mg=nil
		if og then
			mg=og:Filter(c80000295.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c80000295.mfilter,tp,LOCATION_MZONE,0,nil,c)
		end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local minc=3
		local maxc=64
		if min then
			minc=math.max(minc,min)
			maxc=max
		end
		local ct=math.max(minc-1,-ft)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c80000295.xyzfilter1,1,1,nil,mg,ct)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:FilterSelect(tp,c80000295.xyzfilter2,ct,maxc-1,g:GetFirst(),g:GetFirst():GetRank())
		g:Merge(g2)
	end
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		sg:Merge(tc:GetOverlayGroup())
		tc=g:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c80000295.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end 
function c80000295.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000295.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000295.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c80000295.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c80000295.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c80000295.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c80000295.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		local tc=sg:GetFirst()
		if tc:IsType(TYPE_MONSTER) then
			Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
		else
			Duel.Damage(1-tp,1000,REASON_EFFECT) 
		end
	end
end