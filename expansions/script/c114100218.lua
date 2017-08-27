--★愛のサンタ ヒューム
function c114100218.initial_effect(c)
	--xyzsummon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c114100218.xyzcon)
	e1:SetOperation(c114100218.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
function c114100218.mfilter2(c)
	return ( c:IsFaceup() and not c:IsType(TYPE_TOKEN) ) or not c:IsLocation(LOCATION_MZONE)
end

function c114100218.mfilter(c)
	local mg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA,0,nil,114100218)
	local mgtg=mg:GetFirst()
	if mgtg then
		local jud=false
		local lvb=c114100218.lvchk()
		for i=2,lvb do
			if c:IsXyzLevel(mgtg,i) then jud=true end
			if jud then break end
		end
		return jud
	else
		return c:GetLevel()>=2
	end
end

function c114100218.xyzfilter1(c,g,slf)
	return g:IsExists(c114100218.xyzfilter2,1,c,c:GetLevel(),slf)
end
function c114100218.xyzfilter2(c,lv,slf)
	return c:IsXyzLevel(slf,lv)
end

function c114100218.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local jud=false
	local lvb=c114100218.lvchk()
	for i=2,lvb do
		if Duel.CheckXyzMaterial(c,nil,i,2,2,og) then jud=true end
		if jud then break end
	end
	return jud and Duel.GetLocationCount(tp,LOCATION_MZONE)>=-1
end

function c114100218.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local ag=Duel.GetMatchingGroup(c114100218.mfilter2,tp,LOCATION_MZONE,0,nil)
		local pg=Group.CreateGroup()
		local chkpg=false
		local agtg=ag:GetFirst()
		local lvb=c114100218.lvchk()
		while agtg do
			chkpg=false
			for i=2,lvb do
				if Duel.CheckXyzMaterial(c,nil,i,1,1,Group.FromCards(agtg)) then pg:AddCard(agtg) chkpg=true end
				if chkpg then break end
			end
			agtg=ag:GetNext()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g1=pg:FilterSelect(tp,c114100218.xyzfilter1,1,1,nil,pg,c)
		local tc1=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=pg:FilterSelect(tp,c114100218.xyzfilter2,1,1,tc1,tc1:GetLevel(),c)
		g1:Merge(g2)
		c:SetMaterial(g1)
		Duel.Overlay(c,g1)
	end
end
--definition
c114100218.xyz_filter=c114100218.mfilter
c114100218.xyz_count=2

function c114100218.lvchk()
	local lv=13
	local lvmg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if lvmg:GetCount()>0 then
		local lvc=lvmg:GetMaxGroup(Card.GetLevel):GetFirst():GetLevel()
		if lvc>lv then lv=lvc end
	end
	return lv
end
--end of definition