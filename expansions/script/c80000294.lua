--传说中的口袋妖怪 水君
function c80000294.initial_effect(c)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c80000294.xyzcon)
	e1:SetOperation(c80000294.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--wudi 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c80000294.efilter)
	c:RegisterEffect(e2)  
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80000294,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c80000294.cost)
	e3:SetTarget(c80000294.destg)
	e3:SetOperation(c80000294.desop)
	c:RegisterEffect(e3)
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(c80000294.splimit)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80000294,0))
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetCountLimit(1)
	e5:SetCondition(c80000294.atkcon)
	e5:SetCost(c80000294.cost)
	e5:SetTarget(c80000294.target)
	e5:SetOperation(c80000294.atkop)
	c:RegisterEffect(e5)
	--spsummon limit
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	e8:SetValue(c80000294.splimit)
	c:RegisterEffect(e8)
	if not c80000294.xyz_filter then
		c80000294.xyz_filter=function(mc) return mc:IsType(TYPE_XYZ) and mc:IsSetCard(0x2d0) and mc:IsAttribute(ATTRIBUTE_WATER) and mc:IsCanBeXyzMaterial(c) end
	end
end  
function c80000294.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and not (se:GetHandler():IsType(TYPE_SPELL) or se:GetHandler():IsType(TYPE_MONSTER) or se:GetHandler():IsType(TYPE_TRAP))
end  
function c80000294.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x2d0) and c:GetOverlayCount()>0 and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeXyzMaterial(xyzc)
end
function c80000294.xyzfilter1(c,g,ct)
	return g:IsExists(c80000294.xyzfilter2,ct,c,c:GetRank())
end
function c80000294.xyzfilter2(c,rk)
	return c:GetRank()==rk
end
function c80000294.xyzcon(e,c,og,min,max)
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
		mg=og:Filter(c80000294.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c80000294.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	return maxc>=3 and mg:IsExists(c80000294.xyzfilter1,1,nil,mg,ct)
end
function c80000294.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		local mg=nil
		if og then
			mg=og:Filter(c80000294.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c80000294.mfilter,tp,LOCATION_MZONE,0,nil,c)
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
		g=mg:FilterSelect(tp,c80000294.xyzfilter1,1,1,nil,mg,ct)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:FilterSelect(tp,c80000294.xyzfilter2,ct,maxc-1,g:GetFirst(),g:GetFirst():GetRank())
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
function c80000294.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end 
function c80000294.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80000294.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c1=Duel.GetMatchingGroupCount(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	local c2=Duel.GetMatchingGroupCount(Card.IsDestructable,tp,0,LOCATION_SZONE,nil)
	if (c1>c2 and c2~=0) or c1==0 then c1=c2 end
	if c1~=0 then
		local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,c1,0,0)
	end
end
function c80000294.desop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_SZONE,nil)
	if g1:GetCount()>0 or g2:GetCount()>0 then
		if g1:GetCount()==0 then
			Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
		elseif g2:GetCount()==0 then
			Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,0)
			local ac=Duel.SelectOption(tp,aux.Stringid(80000294,2),aux.Stringid(80000294,3))
			if ac==0 then Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
			else Duel.SendtoDeck(g2,nil,2,REASON_EFFECT) end
		end
	end
end
function c80000294.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80000294.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil 
end
function c80000294.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,tc:GetAttack())
end
function c80000294.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local atk=tc:GetAttack()
			Duel.Damage(1-tp,atk,REASON_EFFECT)
			Duel.Recover(tp,atk,REASON_EFFECT)
	end
end